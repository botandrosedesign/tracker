require 'rails_helper'

describe Project, type: :model do
  subject { build :project }

  describe 'validations' do
    describe '#name' do
      before { subject.name = '' }
      it 'should have an error on name' do
        subject.valid?
        expect(subject.errors[:name].size).to eq(1)
      end
    end

    describe '#default_velocity' do
      it 'must be greater than 0' do
        subject.default_velocity = 0
        subject.valid?
        expect(subject.errors[:default_velocity].size).to eq(1)
      end

      it 'must be an integer' do
        subject.default_velocity = 0
        subject.valid?
        expect(subject.errors[:default_velocity].size).to eq(1)
      end
    end

    describe '#point_scale' do
      before { subject.point_scale = 'invalid_point_scale' }
      it 'has an error on point scale' do
        subject.valid?
        expect(subject.errors[:point_scale].size).to eq(1)
      end
    end

    describe '#iteration_length' do
      it 'must be greater than 0' do
        subject.iteration_length = 0
        subject.valid?
        expect(subject.errors[:iteration_length].size).to eq(1)
      end

      it 'must be less than 5' do
        subject.iteration_length = 0
        subject.valid?
        expect(subject.errors[:iteration_length].size).to eq(1)
      end

      it 'must be an integer' do
        subject.iteration_length = 2.5
        subject.valid?
        expect(subject.errors[:iteration_length].size).to eq(1)
      end
    end

    describe '#iteration_start_day' do
      it 'must be greater than -1' do
        subject.iteration_start_day = -1
        subject.valid?
        expect(subject.errors[:iteration_start_day].size).to eq(1)
      end

      it 'must be less than 6' do
        subject.iteration_start_day = 7
        subject.valid?
        expect(subject.errors[:iteration_start_day].size).to eq(1)
      end

      it 'must be an integer' do
        subject.iteration_start_day = 2.5
        subject.valid?
        expect(subject.errors[:iteration_start_day].size).to eq(1)
      end
    end
  end

  describe 'defaults' do
    subject { Project.new }

    its(:point_scale)             { should == 'pivotal' }
    its(:default_velocity)        { should == 10 }
    its(:iteration_length)        { should == 1 }
    its(:iteration_start_day)     { should == 1 }
    its(:suppress_notifications)  { should == false }
  end

  describe 'cascade deletes' do
    before do
      @user     = create(:user)
      @project  = create(:project, users: [@user])
      @story    = create(:story, project: @project,
                                 requested_by: @user)
    end

    specify 'stories' do
      expect do
        @project.destroy
      end.to change(Story, :count).by(-1)
    end
  end

  describe '#to_s' do
    subject { build :project, name: 'Test Name' }

    its(:to_s) { should == 'Test Name' }
  end

  describe '#point_values' do
    its(:point_values) { should == Project::POINT_SCALES['pivotal'] }
  end

  describe '.archived' do
    let(:normal_project) { create :project }
    let(:archived_project) do
      create :project,
      archived_at: Time.current
    end
    subject { described_class.archived }

    it 'includes archived projects' do
      expect(subject).to include archived_project
    end

    it 'excludes non-archived projects' do
      expect(subject).not_to include normal_project
    end
  end

  describe '#iteration_service' do
    let(:iteration_service_stub) { instance_double('IterationService') }

    context 'when since and current_time are defined' do
      let(:since) { Time.current - 1.day }
      let(:current_time) { Time.current }

      before do
        allow(IterationService)
          .to receive(:new)
          .with(subject, since: since, current_time: current_time)
          .and_return(iteration_service_stub)
      end

      it 'uses them to initialize IterationService' do
        expect(subject.iteration_service(since: since, current_time: current_time))
          .to eq iteration_service_stub
      end
    end

    context 'when since and current_time are not defined' do
      let(:current_time) { Time.current }

      before do
        Timecop.freeze(current_time) do
          allow(IterationService)
            .to receive(:new)
            .with(subject, since: nil, current_time: current_time)
            .and_return(iteration_service_stub)
        end
      end

      it 'defaults nil to since and the current time to current_time' do
        Timecop.freeze(current_time) do
          expect(subject.iteration_service).to eq iteration_service_stub
        end
      end
    end
  end


  describe 'associations' do
    subject { build :project }
    it { is_expected.to have_many(:changesets) }
  end

  describe '#joinable' do
    context 'when disallow_join is true' do
      let(:project) { create :project, disallow_join: true }

      it { expect(Project.joinable).not_to include(project) }
    end

    context 'when disallow_join is false' do
      let(:project) { create :project, disallow_join: false }

      it { expect(Project.joinable).to include(project) }
    end
  end

  describe '#joinable_except' do
    context 'when disallow_join is true' do
      let(:project) { create :project, disallow_join: true }
      let(:another_project) { create :project, disallow_join: true }

      it { expect(Project.joinable_except(project.id)).not_to include(project) }
      it { expect(Project.joinable_except(project.id)).not_to include(another_project) }
    end

    context 'when disallow_join is false' do
      let(:project) { create :project, disallow_join: false }
      let(:another_project) { create :project, disallow_join: false }

      it { expect(Project.joinable_except(project.id)).not_to include(project) }
      it { expect(Project.joinable_except(project.id)).to include(another_project) }
    end
  end

  describe '#last_changeset_id' do
    context 'when there are no changesets' do
      before do
        allow(subject).to receive_message_chain(:changesets).and_return([])
      end

      its(:last_changeset_id) { should be_nil }
    end

    context 'when there are changesets' do
      let(:changeset) { double('changeset', id: 42) }

      before do
        allow(subject).to receive(:changesets).and_return([nil, nil, changeset])
      end

      its(:last_changeset_id) { should == changeset.id }
    end
  end

  context 'friendly_id' do
    it 'should create a slug' do
      project = create(:project, name: 'Test Project')
      expect(project.slug).to eq('test-project')
    end

    it 'should return a message error when a slug is reserved word' do
      project = build(:project, name: 'new')
      expect(project.save).to be_falsey
      expect(project.errors.messages.to_h).to include(friendly_id: ['is reserved'])
    end
  end
end
