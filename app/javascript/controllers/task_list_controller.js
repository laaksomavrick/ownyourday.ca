import Sortable from 'stimulus-sortable';

export default class extends Sortable {
  connect() {
    super.connect();
  }

  onUpdate(event) {
    super.onUpdate(event);
  }

  get defaultOptions() {
    return {
      animation: 125,
    };
  }
}
