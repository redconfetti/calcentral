describe Link do
  let(:cs_link_data) do
    {
      urlId: 'UC_CX_GT_GRADEOPT_ADD',
      description: 'Petition for Late Change of Class Schedule',
      hoverOverText: 'Request late add, drop, grading basis, or unit value changes to class schedule',
      properties: [
        {name: 'CALCENTRAL', value: 'FORM'},
        {name: 'NEW_WINDOW', value: 'Y'},
        {name: 'UCFROM', value: 'CalCentral'},
        {name: 'UCFROMLINK', value: 'https://calcentral-dev-01.ist.berkeley.edu/'},
        {name: 'UCFROMTEXT', value: 'CalCentral'},
        {name: 'URI_TYPE', value: 'PL'}
      ],
      url: 'https://example.edu/psp/bcsdev/EMPLOYEE/SA/c/G3FRAME.G3SEARCH_FL.GBL?&G3FORM_FAMILY=STUDENT&G3FORM_TYPE=GRADEOPT&G3FORM_CONDITION=Default&G3FORM_TASK=ADD',
      comments: nil
    },
  end
  subject { described_class.new(link_data) }
end
