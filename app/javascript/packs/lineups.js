import interact from 'interactjs'
import Rails from '@rails/ujs'

// FIXME: don't allow invalid form to be dragged to another spot
// when dragging from bench, spot not set, drag to another spot

// https://github.com/taye/interact.js/issues/79

var startPos = null;

interact('.draggable.bench-hitter')
  .draggable({
    inertia: true,
    autoScroll: true,
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

interact('.batting-spot-form')
  .dropzone({
    accept: ['.bench-hitter', '.spot-hitter-field'],
    listeners: {
      enter: dropEnterListener,
      leave: dropLeaveListener,
      drop: dropEndListener
    }
  })

interact('.spot-hitter-field')
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

  addToLineup(event);
}

// set form fields from dragged and submit
function addToLineup(event) {
  var form = event.currentTarget;
  var hitter = event.relatedTarget;
  var hitterId = hitter.dataset.id;

  if (hitterId && hitterId.length) {
    var formHitterField = form.querySelector('input[name="spot[hitter_id]"]');
    if (formHitterField) {
      // FIXME: if redropping on same spot, don't send extra request
      // if (formHitterField.value == hitterId) {
      formHitterField.value = hitterId;
      Rails.fire(form, 'submit');
    }
  }
}
