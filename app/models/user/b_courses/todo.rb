module User
  module BCourses
    class Todo
      include ActiveModel::Model
      include HasAssignment

      attr_accessor :user,
        :context_type,
        :course_id,
        :type,
        :ignore,
        :ignore_permanently,
        :html_url,
        :needs_grading_count

      def grading?
        type == 'grading'
      end

      def course
        user.b_courses.courses.find_by_id(course_id)
      end

      delegate :course_code, to: :course

      def as_json(options={})
        {
          actionUrl: assignment_url,
          actionText: 'View in bCourses',
          displayCategory: 'bCourses',
          source: 'bCourses',
          type: 'assignment',
          id: id,
          type: type,
          name: name,
          dueDate: due_date,
          dueTime: due_time,
          courseCode: course_code,
          sourceUrl: assignment_url,
          status: 'inprogress',
          title: name,
          description: sanitized_description,
        }
      end
    end
  end
end
