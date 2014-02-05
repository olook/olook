# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CpfValidator do
  let!(:member) { FactoryGirl.create(:member, :cpf => '27958855818') }
  subject { described_class.new({}) }

  it "should add invalid message for invalid CPFs" do
    member.cpf = '111'
    member.errors.should_receive(:add).with(:cpf, 'O CPF parece estranho. Pode conferir?')
    subject.validate(member)
  end
  
  context 'when testing for duplicate CPFs' do
    it 'should add "já cadastrado" if the CPF already exists' do
      new_member = FactoryGirl.build(:member, :cpf => '27958855818')
      new_member.errors.should_receive(:add).with(:cpf, 'Cpf está cadastrado. Entre em contato com o nosso SAC')
      subject.validate(new_member)
    end

    it 'should not add "já cadastrado" if the CPF belongs to the member being saved' do
      member.errors.should_not_receive(:add).with(:cpf, 'Cpf está cadastrado. Entre em contato com o nosso SAC')
      subject.validate(member)
    end
  end
end
