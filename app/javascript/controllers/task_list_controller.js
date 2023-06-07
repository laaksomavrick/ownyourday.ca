import Sortable from 'stimulus-sortable';

export default class extends Sortable {
  connect() {
    super.connect();
  }

  async onUpdate({ item, newIndex }) {
    // https://github.com/stimulus-components/stimulus-sortable/blob/master/src/index.ts
    if (!item.dataset.taskId) return;

    const formField = document.getElementById(
      `task-${item.dataset.taskId}-position-form`,
    );
    const formSubmit = document.getElementById(
      `task-${item.dataset.taskId}-position-form-submit`,
    );

    const positionField = formField.querySelector(
      'input[name="task_position[position]"]',
    );
    positionField.value = newIndex.toString();
    positionField.currentValue = newIndex.toString();

    formSubmit.click();
  }

  get defaultOptions() {
    return {
      animation: 125,
    };
  }
}
