import Sortable from 'stimulus-sortable';

export default class extends Sortable {
  connect() {
    super.connect();
  }
  async onChoose(e) {
    const goalDiv = e.item;

    if (!goalDiv) {
      return;
    }

    goalDiv.classList.add('border-blue-300');
    goalDiv.classList.remove('border-gray-300');
  }

  async onUnchoose(e) {
    const taskDiv = e.item;

    if (!taskDiv) {
      return;
    }

    taskDiv.classList.add('border-gray-300');
    taskDiv.classList.remove('border-blue-300');
  }

  async onUpdate({ item, newIndex }) {
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
      delay: 25,
      onChoose: this.onChoose,
      onUnchoose: this.onUnchoose,
    };
  }
}
