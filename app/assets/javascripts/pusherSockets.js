import Pusher from 'pusher-js';

const matchPusherUrl = url => {
  const pusherArgsRegex = /\/\/ws-(.*)\.pusher.*\/(.*)$/;
  return url.match(pusherArgsRegex);
};

export const subscribeToProjectChanges = (project, callback) => {
  const pusherUrl = process.env.PUSHER_SOCKET_URL;
  const [
    _,
    pusherCluster,
    pusherApiKey
  ] = matchPusherUrl(pusherUrl) || [];

  if (!pusherApiKey || !pusherCluster) {
    return;
  }

  const socket = getProjectSocket(pusherApiKey, pusherCluster);

  if (!socket) {
    return;
  }

  const channel = socket.subscribe('project-board-' + project.id);

  channel.bind('notify_changes', callback);
};

const getProjectSocket = (apiKey, apiCluster) => {
  try {
    return new Pusher(apiKey, {
      cluster: apiCluster,
      encrypted: true
    });
  } catch (error) {
    console.error(error);
    return;
  }
};