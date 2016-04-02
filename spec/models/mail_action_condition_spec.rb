require 'rails_helper'

RSpec.describe MailActionCondition, type: :model do
  let(:cond) { create(:mail_action_condition) }

  describe 'validations' do
    it { should validate_presence_of(:json_path) }
    it { should validate_presence_of(:cond_op) }
    it { should validate_presence_of(:match_value) }

    it do
      should allow_values(*MailActionCondition::VALID_CONDS).for(:cond_op)
    end

    it do
      should_not allow_values('EQ', 'LESS', 'another').for(:cond_op)
    end
  end

  describe '.data_stisfy?' do
    let(:valid_json_path) { 'body_data.user.size' }
    let(:invalid_json_path) { 'body_data.user.ize' }
    let(:event_data) do
      {
        subject_data: { user_name: 'foo' },
        body_data: { user: { size: 10 } }
      }
    end
    let(:cond) do
      create(
        :mail_action_condition,
        json_path: json_path,
        cond_op: cond_op,
        match_value: cond_match_value
      )
    end
    let(:json_path) { valid_json_path }
    let(:cond_match_value) { 10 }

    subject { cond.data_satisfy?(event_data) }

    context 'should be false when invalid json_path' do
      let(:cond_op) { 'eq' }
      let(:json_path) { invalid_json_path }
      it { is_expected.to eq(false) }
    end

    context 'with eq condition' do
      let(:cond_op) { 'eq' }

      context 'should be true when condition match' do
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 8 }
        it { is_expected.to eq(false) }
      end
    end

    context 'with not_eq condition' do
      let(:cond_op) { 'not_eq' }

      context 'should be true when condition match' do
        let(:cond_match_value) { 8 }
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 10 }
        it { is_expected.to eq(false) }
      end
    end

    context 'with gt_that condition' do
      let(:cond_op) { 'gt_that' }

      context 'should be true when condition match' do
        let(:cond_match_value) { 11 }
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 10 }
        it { is_expected.to eq(false) }
      end
    end

    context 'with gt_or_eq_that condition' do
      let(:cond_op) { 'gt_or_eq_that' }

      context 'should be true when condition match' do
        let(:cond_match_value) { 11 }
        it { is_expected.to eq(true) }
      end

      context 'should be true when condition match' do
        let(:cond_match_value) { 10 }
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 9 }
        it { is_expected.to eq(false) }
      end
    end

    context 'with lt_that condition' do
      let(:cond_op) { 'lt_that' }

      context 'should be true when condition match' do
        let(:cond_match_value) { 9 }
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 10 }
        it { is_expected.to eq(false) }
      end
    end

    context 'with lt_or_eq_that condition' do
      let(:cond_op) { 'lt_or_eq_that' }

      context 'should be true when condition match' do
        let(:cond_match_value) { 9 }
        it { is_expected.to eq(true) }
      end

      context 'should be true when condition match' do
        let(:cond_match_value) { 10 }
        it { is_expected.to eq(true) }
      end

      context 'should be false when condition dont match' do
        let(:cond_match_value) { 11 }
        it { is_expected.to eq(false) }
      end
    end

  end
end
