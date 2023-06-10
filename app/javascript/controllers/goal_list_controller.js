import Sortable from 'stimulus-sortable';

export default class extends Sortable {
  connect() {
    super.connect();
  }

  async onUpdate({ item, newIndex }) {
    console.log('here')
    // https://github.com/stimulus-components/stimulus-sortable/blob/master/src/index.ts
    if (!item.dataset.goalId) return;

    const formField = document.getElementById(
      `goal-${item.dataset.goalId}-position-form`,
    );
    const formSubmit = document.getElementById(
      `goal-${item.dataset.goalId}-position-form-submit`,
    );

    const positionField = formField.querySelector(
      'input[name="goal_position[position]"]',
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
