export default () => {
  const taskListPage = document.getElementById('task-list');

  if (!taskListPage) {
    return;
  }

  document.addEventListener('visibilitychange', function () {
    if (document.hidden) {
      return;
    }

    location.reload();
  });
};
