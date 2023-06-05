import Sortable from 'stimulus-sortable';
import { patch } from '@rails/request.js';

export default class extends Sortable {
  connect() {
    super.connect();
  }

  async onUpdate({ item, newIndex }) {
    // https://github.com/stimulus-components/stimulus-sortable/blob/master/src/index.ts
    console.log(item);
    if (!item.dataset.sortableUpdateUrl) return;
    if (!item.dataset.taskType) return;

    const data = new FormData();
    // Remove 1 indexing
    data.append('position', newIndex);
    data.append('type', item.dataset.taskType);

    await patch(item.dataset.sortableUpdateUrl, { body: data });
  }

  get defaultOptions() {
    return {
      animation: 125,
    };
  }
}
