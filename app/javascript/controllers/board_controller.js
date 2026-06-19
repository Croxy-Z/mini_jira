import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="board"
export default class extends Controller {
    connect() {
        this.sortables = []

        this.columns.forEach((column) => {
            this.sortables.push(
                Sortable.create(column, {
                    group: "tasks",
                    animation: 150,
                    draggable: "[data-task-id]",
                    onEnd: this.handleEnd.bind(this)
                })
            )
        })
    }

    disconnect() {
        this.sortables.forEach((sortable) => sortable.destroy())
    }

    get columns() {
        return this.element.querySelectorAll("[data-status]")
    }

    async handleEnd(event) {
        const taskCard = event.item
        const oldColumn = event.from
        const oldIndex = event.oldIndex
        const newStatus = event.to.dataset.status
        const moveUrl = taskCard.dataset.moveUrl

        if (event.from === event.to) {
            this.rollback(taskCard, oldColumn, oldIndex)
            return
        }

        try {
            const response = await fetch(moveUrl, {
                method: "PATCH",
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "X-CSRF-Token": this.csrfToken
                },
                body: JSON.stringify({
                    task: {
                        status: newStatus
                    }
                })
            })

            if (!response.ok) {
                console.error("Failed to move task", await response.json())
                this.rollback(taskCard, oldColumn, oldIndex)
                this.refreshColumns(oldColumn, event.to)
                return
            }

            console.debug("Task moved successfully", await response.json())
            this.refreshColumns(oldColumn, event.to)

        } catch (error) {
            console.error("Failed to move task", error)
            this.rollback(taskCard, oldColumn, oldIndex)
            this.refreshColumns(oldColumn, event.to)
        }
    }

    rollback(taskCard, oldColumn, oldIndex) {
        const referenceNode = oldColumn.children[oldIndex]

        oldColumn.insertBefore(taskCard, referenceNode || null)
    }

    refreshColumns(...columns) {
        columns.forEach((column) => {
            this.updateColumnCount(column)
            this.updateColumnEmptyState(column)
        })
    }

    updateColumnCount(column) {
        const counter = document.getElementById(`${column.id}_count`)

        if (!counter) return

        counter.textContent = this.taskCards(column).length.toString()
    }

    updateColumnEmptyState(column) {
        const emptyState = document.getElementById(`${column.id}_empty_state`)

        if (!emptyState) return

        emptyState.hidden = this.taskCards(column).length > 0
    }

    taskCards(column) {
        return column.querySelectorAll("[data-task-id]")
    }

    get csrfToken() {
        return document.querySelector("meta[name='csrf-token']")?.content || ""
    }
}