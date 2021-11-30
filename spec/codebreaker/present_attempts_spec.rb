# frozen_string_literal: true

module Codebreaker
  RSpec.shared_examples 'callable attempts' do
    before { stub_const('Codebreaker::Game::DIFFICULTIES', { difficulty => { attempts: 1, hints: 1 } }) }

    let(:game) { Game.new }

    before(:each) do
      game.start
      game.difficulty = difficulty
    end

    context '#present_attempts' do
      it 'should return true if attempt was not use' do
        expect(game.present_attempts?).to be_truthy
      end

      it 'should return false if attempt was use' do
        game.matrix_generator('1111')
        expect(game.present_attempts?).to be_falsey
      end
    end
  end

  RSpec.describe Game do
    context 'easy' do
      it_behaves_like 'callable attempts' do
        let(:difficulty) { :easy }
      end
    end

    context 'medium' do
      it_behaves_like 'callable attempts' do
        let(:difficulty) { :medium }
      end
    end

    context 'hell' do
      it_behaves_like 'callable attempts' do
        let(:difficulty) { :hell }
      end
    end
  end
end
