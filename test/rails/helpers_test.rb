require 'test_helper'

class HelpersTest < ActionController::TestCase
  tests ApplicationController

  def setup
    @warden = mock()
    @controller.request.env['warden'] = @warden
  end

  test 'proxy to Warden manager' do
    assert_equal @controller.warden, @warden
  end

  test 'proxy #login to Warden #authenticate' do
    @warden.expects(:authenticate).with(:my_strategy, :scope => :user)
    @controller.login(:my_strategy, :scope => :user)
  end

  test 'proxy #login? to Warden #authenticate?' do
    @warden.expects(:authenticate?).with(:my_strategy, :scope => :user)
    @controller.login?(:my_strategy, :scope => :user)
  end

  test 'proxy #login! to Warden #authenticate!' do
    @warden.expects(:authenticate!).with(:my_strategy, :scope => :user)
    @controller.login!(:my_strategy, :scope => :user)
  end

  test 'proxy #logout to Warden #logout' do
    @warden.expects(:raw_session)
    @warden.expects(:logout).with(:user)
    @controller.logout(:user)
  end

  test 'proxy #logged_in? to Warden #authenticated?' do
    @warden.expects(:authenticated?).with(:user)
    @controller.logged_in?(:user)
  end

  test 'proxy #logged_user to Warden #user' do
    @warden.expects(:user).with(:user)
    @controller.logged_user(:user)
  end

  test 'proxy #set_user to Warden #set_user' do
    user = mock('User')
    @warden.expects(:set_user).with(user, :user)
    @controller.set_user(user, :user)
  end
end
