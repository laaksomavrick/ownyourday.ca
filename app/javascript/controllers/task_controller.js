import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['toggleGoalCompletion', 'checkbox', 'submit', 'listItem'];

  toggleGoalCompletion(e) {
    console.log('toggling goal completion');

    const target = e.target.dataset.taskTarget;

    if (target === 'submit') {
      return;
    }

    if (target !== 'checkbox') {
      this.checkboxTarget.checked = !this.checkboxTarget.checked;
    }

    if (this.checkboxTarget.checked) {
      this.listItemTarget.classList.add('opacity-50');
    } else {
      this.listItemTarget.classList.remove('opacity-50');
    }

    this.submitTarget.click();
  }
}
