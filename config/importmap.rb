# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'addReloadToTasksOnActive'

pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
pin 'stimulus-sortable', to: 'https://ga.jspm.io/npm:stimulus-sortable@4.1.0/dist/stimulus-sortable.mjs'
pin '@rails/request.js', to: 'https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js'
