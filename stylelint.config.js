// https://github.com/cahamilton/stylelint-config-property-sort-order-smacss

const sortOrderSmacss = require('stylelint-config-property-sort-order-smacss/generate');

module.exports = {
  extends: 'stylelint-config-sass-guidelines',
  plugins: ['stylelint-order', 'stylelint-scss'],
  rules: {
    'indentation': [2, { ignore: ['value'] }],
    'order/properties-alphabetical-order': null,
    'order/properties-order': [sortOrderSmacss()],
    'max-nesting-depth': 4,
    'number-leading-zero': null,
    'selector-no-qualifying-type': [true, { ignore: ['class'] }]
  }
};
