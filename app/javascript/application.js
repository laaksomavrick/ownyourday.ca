// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import Sortable from 'stimulus-sortable';
import 'controllers';
import addReloadToTasksOnActive from './snippets/addReloadToTasksOnActive';

const application = Application.start();
application.register('sortable', Sortable);
document.addEventListener('turbo:load', () => {
  addReloadToTasksOnActive();
});
