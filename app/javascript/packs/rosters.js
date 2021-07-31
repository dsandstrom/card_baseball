import interact from 'interactjs'
import Rails from '@rails/ujs'

// https://github.com/taye/interact.js/issues/79

// TODO: share code with lineups

var startPos = null;

interact('.draggable.rosterless-player')
  .draggable({
    inertia: true,
    autoScroll: false,
    snap: {
      targets: [startPos],
      range: Infinity,
      relativePoints: [{ x: 0.5, y: 0.5 }],
      endOnly: true
    },
    listeners: {
      start: dragStartListener,
      move: dragMoveListener,
      end: dragEndListener
    }
  })

interact('.roster-position-form')
  .dropzone({
    accept: ['.rosterless-player', '.roster-field'],
    listeners: {
      enter: dropEnterListener,
      leave: dropLeaveListener,
      drop: dropEndListener
    }
  })

interact('.roster-field')
  .draggable({
    inertia: true,
    snap: {
      targets: [startPos],
      range: Infinity,
      relativePoints: [{ x: 0.5, y: 0.5 }],
      endOnly: true
    },
    listeners: {
      start: dragStartListener,
      move: dragMoveListener,
      end: dragEndListener
    }
  })

function dragStartListener (event) {
  var rect = interact.getElementRect(event.target);

  // record center point when starting the very first a drag
  startPos = {
    x: rect.left + rect.width  / 2,
    y: rect.top  + rect.height / 2
  }

  // snap to the start position
  event.interactable.draggable({
    snap: {
      targets: [startPos]
    }
  });
}

function dragMoveListener (event) {
  var target = event.target
  // keep the dragged position in the data-x/data-y attributes
  var x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx
  var y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy

  // translate the element
  target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'

  // update the posiion attributes
  target.setAttribute('data-x', x)
  target.setAttribute('data-y', y)

  target.classList.add('drag-moving');
}

function dragEndListener (event) {
  var target = event.target
  target.classList.remove('drag-moving');
}

function dropEnterListener (event) {
  var draggableElement = event.relatedTarget,
      dropzoneElement  = event.target,
      dropRect         = interact.getElementRect(dropzoneElement),
      dropCenter       = {
          x: dropRect.left + dropRect.width  / 2,
          y: dropRect.top  + dropRect.height / 2
      };

  event.draggable.draggable({
    snap: {
        targets: [dropCenter]
    }
  });

  var target = event.target
  target.classList.add('drag-over');
}

function dropLeaveListener (event) {
  event.draggable.draggable({
    snap: {
        targets: [startPos]
    }
  });

  var target = event.target
  target.classList.remove('drag-over');
}

function dropEndListener (event) {
  var target = event.target
  target.classList.remove('drag-moving');

  addRoster(event);
}

// set form fields from dragged and submit
function addRoster(event) {
  var form = event.currentTarget;
  var player = event.relatedTarget;
  var playerId = player.dataset.id;

  if (playerId && playerId.length) {
    var formPlayerField = form.querySelector('input[name="roster[player_id]"]');
    if (formPlayerField) {
      console.log(formPlayerField);
      // FIXME: if redropping on same roster, don't send extra request
      // if (formPlayerField.value == playerId) {
      formPlayerField.value = playerId;
      Rails.fire(form, 'submit');
    }
  }
}
