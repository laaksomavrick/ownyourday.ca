import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  open() {
    // Mobile browsers open their date picker when the input is tapped; desktop browsers need showPicker
    try {
      this.inputTarget.showPicker();
    } catch {
      // Not supported, or already open
    }
  }

  submit() {
    if (!this.inputTarget.value) return;

    this.element.requestSubmit();
  }
}
