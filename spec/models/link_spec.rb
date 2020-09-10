describe Link do
  let(:calcentral_property) { {name: 'CALCENTRAL', value: 'FORM'} }
  let(:new_window_property) { {name: 'NEW_WINDOW', value: 'Y'} }
  let(:uc_from_property) { {name: 'UCFROM', value: 'CalCentral'} }
  let(:uc_from_link_property) { {name: 'UCFROMLINK', value: 'https://calcentral-dev-01.ist.berkeley.edu/'} }
  let(:uc_from_text_property) { {name: 'UCFROMTEXT', value: 'CalCentral'} }
  let(:uri_type_property) { {name: 'URI_TYPE', value: 'PL'} }
  let(:properties_data) do
    [
      calcentral_property,
      new_window_property,
      uc_from_property,
      uc_from_link_property,
      uc_from_text_property,
      uri_type_property,
    ].compact
  end
  let(:link_data) do
    {
      urlId: 'UC_CX_GT_GRADEOPT_ADD',
      description: 'Petition for Late Change of Class Schedule',
      hoverOverText: 'Request late add, drop, grading basis, or unit value changes to class schedule',
      properties: properties_data,
      url: 'https://example.com/psp/bcsdev/EMPLOYEE/PSFT_CS/c/AB_CD_EF_GHIJK.GBL?EMPLID={EMPLID}&TERM_ID={TERM_ID}',
      comments: 'this is a comment'
    }
  end
  let(:user_id) { '61889' }
  let(:emplid) { '11667051' }
  let(:term_id) { '2208' }
  before { subject.parameters = {EMPLID: emplid, TERM_ID: term_id} }
  subject { described_class.new(link_data) }

  its(:id) { should eq 'UC_CX_GT_GRADEOPT_ADD' }
  its(:name) { should eq 'Petition for Late Change of Class Schedule' }
  its(:title) { should eq 'Request late add, drop, grading basis, or unit value changes to class schedule' }
  its(:comments) { should eq 'this is a comment' }

  describe '#url' do
    context 'when parameters are configured for the link' do
      it 'returns link with parameters merged' do
        expect(subject.url).to eq 'https://example.com/psp/bcsdev/EMPLOYEE/PSFT_CS/c/AB_CD_EF_GHIJK.GBL?EMPLID=11667051&TERM_ID=2208'
      end
    end
  end

  describe '#properties' do
    let(:properties) { subject.properties }
    it 'returns properties object' do
      expect(properties).to be_an_instance_of LinkProperties
    end
  end

  describe '#as_json' do
    let(:json_hash) { subject.as_json }
    it 'returns hash for json' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash[:urlId]).to eq 'UC_CX_GT_GRADEOPT_ADD'
      expect(json_hash[:url]).to eq 'https://example.com/psp/bcsdev/EMPLOYEE/PSFT_CS/c/AB_CD_EF_GHIJK.GBL?EMPLID=11667051&TERM_ID=2208'
      expect(json_hash[:ucFrom]).to eq 'CalCentral'
      expect(json_hash[:ucFromLink]).to eq 'https://calcentral-dev-01.ist.berkeley.edu/'
      expect(json_hash[:ucFromText]).to eq 'CalCentral'
      expect(json_hash[:name]).to eq 'Petition for Late Change of Class Schedule'
      expect(json_hash[:title]).to eq 'Request late add, drop, grading basis, or unit value changes to class schedule'
      expect(json_hash[:comments]).to eq 'this is a comment'
      expect(json_hash[:showNewWindow]).to eq true
      expect(json_hash[:isCampusSolutionsLink]).to eq true
    end
  end

  describe '#uc_from' do
    let(:uc_from) { subject.uc_from }
    context 'when UCFROM property is not present' do
      let(:uc_from_property) { nil }
      it 'should be nil' do
        expect(uc_from).to eq nil
      end
    end
    context 'when UCFROM property is present' do
      let(:uc_from_property) { {name: 'UCFROM', value: 'CalCentral'} }
      it 'should return value' do
        expect(uc_from).to eq 'CalCentral'
      end
    end
  end

  describe '#show_new_window?' do
    let(:show_new_window) { subject.show_new_window? }
    context 'when NEW_WINDOW property is Y' do
      let(:new_window_property) { {name: 'NEW_WINDOW', value: 'Y'} }
      it 'returns true' do
        expect(show_new_window).to eq true
      end
    end
    context 'when NEW_WINDOW property is not Y' do
      let(:new_window_property) { {name: 'NEW_WINDOW', value: 'N'} }
      it 'returns false' do
        expect(show_new_window).to eq false
      end
    end
    context 'when NEW_WINDOW property is not present' do
      let(:new_window_property) { nil }
      it 'returns false' do
        expect(show_new_window).to eq false
      end
    end
  end

  describe '#is_campus_solutions_link?' do
    let(:is_cs_link) { subject.is_campus_solutions_link? }
    context 'when link does not have URI_TYPE property with value \'PL\'' do
      let(:uri_type_property) { nil }
      it 'returns false' do
        expect(is_cs_link).to eq false
      end
    end
    context 'when link has URI_TYPE property with value \'PL\'' do
      let(:uri_type_property) { {name: 'URI_TYPE', value: 'PL'} }
      it 'returns true' do
        expect(is_cs_link).to eq true
      end
    end
  end

end
