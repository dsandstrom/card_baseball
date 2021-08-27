class ToggleLink {
  constructor(elem) {
    this.elem = elem;
    this.targetId = elem.dataset.target;
    if (!this.targetId) return;

    this.target = document.getElementById(this.targetId);
    if (!this.target) return;

    this.watchLink();
  }

  watchLink() {
    toggleLink = this;
    toggleLink.elem.addEventListener('click', function() {
      if (toggleLink.target.classList.contains('inactive')) {
        toggleLink.target.classList.remove('inactive');
        toggleLink.elem.classList.add('toggle-on')
      }
    })
  }

  toggleOn() {
    this.target.classList.remove('inactive');
    this.elem.classList.add('toggle-on')
  }

  toggleOff() {
    this.target.classList.add('inactive');
    this.elem.classList.remove('toggle-on')
  }
}

var toggleLinks = [];

document.addEventListener('turbolinks:load', function() {
  for (var elem of document.querySelectorAll('.toggle-link')) {
    toggleLinks.push(new ToggleLink(elem));
  }
})

document.addEventListener('turbolinks:visit', function() {
  for (var toggleLink of toggleLinks) {
    toggleLink.toggleOff();
  }
  toggleLinks = [];
})
