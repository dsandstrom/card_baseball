import Rails from '@rails/ujs'

class SubmittingRadioButtonLabel {
  constructor(elem) {
    this.elem = elem;
    this.radio = this.elem.querySelector('input');
    this.elem.classList.add('radio-button-label');
    this.toggleDisabledClass();
  }

  checked() { return this.radio.checked; }

  toggleDisabledClass() {
    if (this.checked()) {
      this.elem.classList.remove('disabled');
      this.elem.classList.add('active');
    } else {
      this.elem.classList.add('disabled');
      this.elem.classList.remove('active');
    }
  }
}

class SubmittingRadioButtons {
  constructor(elem) {
    if (elem.classList.contains('submitting-radio-buttons')) {
      return;
    } else {
      elem.classList.add('submitting-radio-buttons');
    }

    this.form = elem.closest('form');
    if (!this.form) return;

    this.labels = [];
    for (var label of elem.querySelectorAll('label')) {
      this.labels.push(new SubmittingRadioButtonLabel(label));
    }
    if (!this.labels.length) return;

    this.watchForChanges();
  }

  watchForChanges() {
    for (var label of this.labels) {
      const radio = label.elem.querySelector('input');
      if (!radio) return;

      radio.addEventListener('change', () => {
        Rails.fire(this.form, 'submit');
        return;
      });
    }
  }
}

const enableSubmittingRadioButtons = function (event) {
  const classes = ['spot-player-positions'];

  for (let klass of classes) {
    document.querySelectorAll('.' + klass).forEach((radioButtons) => {
      new SubmittingRadioButtons(radioButtons);
    });
  }
};

document.addEventListener('turbolinks:load', enableSubmittingRadioButtons);
document.addEventListener('custom:reload-forms', enableSubmittingRadioButtons);
