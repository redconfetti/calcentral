import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import ReduxProvider from 'components/ReduxProvider';
import { react2angular } from 'react2angular';
import { parseISO } from 'date-fns';

import LawEnrollmentAppointments from './LawEnrollmentAppointments';
import Deadlines from './Deadlines';
import TimeCell from './TimeCell';

const EnrollmentAppointments = ({ instruction, enrollmentTerms }) => {
  const { termIsSummer, termId, careerCode } = instruction;

  const appointmentTerm = enrollmentTerms.find(term => {
    return (
      term.termId === termId &&
      term.career.toLowerCase() === careerCode.toLowerCase()
    );
  });

  if (appointmentTerm && appointmentTerm.enrollmentPeriods.length > 0) {
    const style = {
      th: {
        fontSize: `11px`,
        fontWeight: `bold`,
      },
    };

    if (careerCode === 'LAW') {
      return (
        <LawEnrollmentAppointments
          appointmentTerm={appointmentTerm}
          termIsSummer={termIsSummer}
        />
      );
    }

    return (
      <div style={{ marginBottom: `15px`, marginTop: `15px` }}>
        <h4 className="cc-enrollment-card-headersub-title">
          Enrollment Period <span>(Pacific Time)</span>
        </h4>

        <div className="cc-table" style={{ marginTop: `10px` }}>
          <table>
            <thead>
              <tr>
                <th scope="col" style={style.th}>
                  Period
                </th>
                <th scope="col" style={style.th}>
                  Start
                </th>
                {!termIsSummer && (
                  <th scope="col" style={style.th}>
                    End
                  </th>
                )}
              </tr>
            </thead>
            <tbody>
              {appointmentTerm.enrollmentPeriods.map(period => (
                <tr key={period.id}>
                  <td>{period.name.replace(' Begins', '')}</td>
                  <td>
                    <TimeCell time={parseISO(period.beginTime.pacific)} />
                  </td>
                  {!termIsSummer && (
                    <td>
                      <TimeCell time={parseISO(period.endTime.pacific)} />
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {!termIsSummer && appointmentTerm.constraints && (
          <Deadlines
            constraints={appointmentTerm.constraints}
            programCode={appointmentTerm.programCode}
          />
        )}
      </div>
    );
  } else {
    return null;
  }
};

EnrollmentAppointments.propTypes = {
  instruction: PropTypes.object,
  enrollmentTerms: PropTypes.array,
};

const mapStateToProps = ({ myEnrollments: { enrollmentTerms = [] } = {} }) => {
  return {
    enrollmentTerms,
  };
};

const ConnectedEnrollmentAppointments = connect(mapStateToProps)(
  EnrollmentAppointments
);

const EnrollmentAppointmentsContainer = ({ instruction }) => (
  <ReduxProvider>
    <ConnectedEnrollmentAppointments instruction={instruction} />
  </ReduxProvider>
);

EnrollmentAppointmentsContainer.propTypes = {
  instruction: PropTypes.object,
};

export default EnrollmentAppointments;

angular
  .module('calcentral.react')
  .component(
    'enrollmentAppointments',
    react2angular(EnrollmentAppointmentsContainer)
  );
