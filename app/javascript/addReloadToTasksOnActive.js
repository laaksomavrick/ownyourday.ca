const addReloadToTasksOnActive = () => {
  const taskListPage = document.getElementById('task-list');

  if (!taskListPage) {
    return;
  }

  document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
      return;
    }

    location.reload();
  });
};

export default (() =>
  document.addEventListener('turbo:load', addReloadToTasksOnActive))();
