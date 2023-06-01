import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['toggleGoalCompletion', 'checkbox', 'submit'];

  toggleGoalCompletion(e) {
    const target = e.target.dataset.taskTarget

    if (target === 'submit') {
      return
    }

    this.checkboxTarget.checked = !this.checkboxTarget.checked
    this.submitTarget.click();

  }
}
