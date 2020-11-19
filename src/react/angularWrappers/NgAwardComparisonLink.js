import React from 'react';
import PropTypes from 'prop-types';
import { react2angular } from 'react2angular';

import ReduxProvider from 'components/ReduxProvider';
import AwardComparisonLink from 'react/components/_finances/AwardComparison/AwardComparisonLink';

function NgAwardComparisonLink({year}) {
  return (
    <ReduxProvider>
      <AwardComparisonLink year={year} />
    </ReduxProvider>
  );
}

NgAwardComparisonLink.propTypes = {
  year: PropTypes.string,
};

angular
  .module('calcentral.react')
  .component('awardComparisonLink', react2angular(NgAwardComparisonLink));
