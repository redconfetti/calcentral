describe Links do
  let(:cs_link_data) do
    {
      ucCxGtGradeoptAdd: {urlId: 'UC_CX_GT_GRADEOPT_ADD'},
      ucCcCovidResourceUrl4: {urlId: 'UC_CC_COVID_RESOURCE_URL4'},
    }
  end
  let(:cs_links_response) { {statusCode: 200, feed: {ucLinkResources: {links: cs_link_data}}} }
  let(:cs_links_object) { double(get: cs_links_response) }
  before do
    allow(CampusSolutions::Link).to receive(:new).and_return(cs_links_object)
  end

  describe '.find' do
    let(:result) { described_class.find(link_id, {EMPLID: '61889'}) }
    context 'when link present' do
      let(:link_id) { 'UC_CX_GT_GRADEOPT_ADD' }
      it 'returns link initialized with parameters' do
        expect(result).to be_an_instance_of Link
        expect(result.id).to eq 'UC_CX_GT_GRADEOPT_ADD'
        expect(result.parameters[:EMPLID]).to eq '61889'
      end
    end
    context 'when link not present' do
      let(:link_id) { 'UC_CX_GT_GRADEOPT_EDIT' }
      it 'returns nil' do
        expect(result).to eq nil
      end
    end
  end

  describe '#find' do
    it 'returns nil when link not present' do
      link = subject.find('UC_CX_GT_GRADEOPT_EDIT')
      expect(link).to eq nil
    end
    it 'returns link when link is present' do
      link = subject.find('UC_CX_GT_GRADEOPT_ADD')
      expect(link).to be_an_instance_of Link
      expect(link.id).to eq 'UC_CX_GT_GRADEOPT_ADD'
    end
  end

  describe '#all' do
    let(:all_links) { subject.all }
    it 'returns link objects' do
      expect(all_links).to be_an_instance_of Array
      expect(all_links.count).to eq 2
      all_links.each do |link|
        expect(link).to be_an_instance_of Link
      end
    end
  end

  describe '#campus_links' do
    let(:link_json) do
      {
        'links' => [
          {
            'name' => 'Static Link 1 Name',
            'hoverText' => 'Static Link 1 Description',
            'url' => 'http://www.example.com/static_link_1/',
          },
          {
            'cs_link_id' => 'UC_CX_ACCOMM_HUB_STUDENT'
          },
          {
            'name' => 'Static Link 2 Name',
            'hoverText' => 'Static Link 2 Description',
            'url' => 'http://www.example.com/static_link_2/',
          },
        ],
        'navigation' => []
      }
    end
    let(:cs_link_hash) do
      {
        urlId: 'UC_CX_ACCOMM_HUB_STUDENT',
        url: 'https://bcs.example.com:1234/accommodation_hub_student',
        ucFrom: 'CalCentral',
        ucFromText: 'CalCentral',
        ucFromLink: 'https://calcentral-sis01.example.com/',
        name: 'Academic Accommodations Hub',
        title: 'Academic Accommodations Hub for Students',
        isCsLink: true
      }
    end
    before do
      allow(subject).to receive(:campus_links_json).and_return(link_json)
      allow(LinkFetcher).to receive(:fetch_link).with('UC_CX_ACCOMM_HUB_STUDENT').and_return(cs_link_hash)
    end
    it 'should merge cs link api properties with link when cs_link_id present' do
      links = subject.campus_links
      links_array = links['links']
      expect(links_array[0]['name']).to eq 'Static Link 1 Name'
      expect(links_array[1]['name']).to eq 'Academic Accommodations Hub'
      expect(links_array[1]['hoverText']).to eq 'Academic Accommodations Hub for Students'
      expect(links_array[1]['url']).to eq 'https://bcs.example.com:1234/accommodation_hub_student'
      expect(links_array[1][:ucFrom]).to eq 'CalCentral'
      expect(links_array[1][:ucFromText]).to eq 'CalCentral'
      expect(links_array[1][:ucFromLink]).to eq 'https://calcentral-sis01.example.com/'
      expect(links_array[2]['name']).to eq 'Static Link 2 Name'
    end
  end
end
