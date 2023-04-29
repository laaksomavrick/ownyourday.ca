import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['changeGoalSchedule'];

  changeGoalSchedule() {
    this.changeGoalScheduleTarget.click();
  }
}
