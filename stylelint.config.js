// https://github.com/cahamilton/stylelint-config-property-sort-order-smacss

const sortOrderSmacss = require('stylelint-config-property-sort-order-smacss/generate');

module.exports = {
  plugins: ['stylelint-order'],
  rules: {
    'order/properties-order': [
      sortOrderSmacss()
    ]
  },
};
