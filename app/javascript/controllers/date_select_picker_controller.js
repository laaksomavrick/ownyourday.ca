import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['dateSelectPicker'];
  static classes = ['hidden'];

  toggle() {
    const isHidden = this.dateSelectPickerTarget.classList.contains(
      this.hiddenClass,
    );
    if (isHidden) {
      this.dateSelectPickerTarget.classList.remove(this.hiddenClass);
    } else {
      this.dateSelectPickerTarget.classList.add(this.hiddenClass);
    }
  }
}
