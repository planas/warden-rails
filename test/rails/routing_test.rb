require 'test_helper'

class RoutingTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    @routes = Dummy::Application.routes
    @user = stub( :id => 1, :blocked? => false, :role => :admin )
  end

  def set_authenticated_constraint(scope = nil, block = nil)
    @routes.draw do
      authenticated scope, block do
        root to: 'dummy#dashboard'
      end

      root to: 'dummy#home'
    end
  end

  def set_authenticated_constraint!(scope = nil, block = nil)
    @routes.draw do
      authenticated! scope, block do
        root to: 'dummy#dashboard'
      end

      root to: 'dummy#home'
    end
  end

  def set_unauthenticated_constraint(scope = nil)
    @routes.draw do
      unauthenticated scope do
        root to: 'dummy#home'
      end

      root to: 'dummy#dashboard'
    end
  end

  # authenticated

  test 'authenticated should match the given routes when there is a user logged in with any scope' do
    set_authenticated_constraint
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'authenticated should match the given routes when there is a user logged in for a given scope' do
    set_authenticated_constraint(:user)
    login_as(@user, :scope => :user )
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'authenticated should match the given routes when there is a user logged in that meets block conditions' do
    set_authenticated_constraint(:user, Proc.new { |user| !user.blocked? })
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'authenticated should not match the given routes when there is no user logged in' do
    set_authenticated_constraint
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  test 'authenticated should not match the given routes when there is no user logged in with a given scope' do
    set_authenticated_constraint(:admin)
    login_as(@user, :scope => :user )
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  test 'authenticated should not match the given routes when there is a user logged in but it does not meets block conditions' do
    set_authenticated_constraint(:user, Proc.new { |user| user.blocked? })
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  # authenticated!

  test 'authenticated! should match the given routes when there is a user logged in with any scope' do
    set_authenticated_constraint!
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'authenticated! should match the given routes when authentication attempt success' do
    set_authenticated_constraint!
    login_as(@user)
    post root_path, { :login => true }

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'authenticated! should not match the given routes when there is no user logged in with any scope' do
    set_authenticated_constraint!
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  test 'authenticated! should not match the given routes when authentication attempt fails' do
    set_authenticated_constraint!
    post root_path, { :login => false }

    assert response.body.include?('<h1>Home</h1>')
  end

  # unauthenticated

  test 'unauthenticated should match the given routes when there is no user logged in' do
    set_unauthenticated_constraint
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  test 'unauthenticated should not match the given routes when there is a user logged in' do
    set_unauthenticated_constraint
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end

  test 'unauthenticated should match the given routes when there is a user logged in with different scope' do
    set_unauthenticated_constraint(:admin)
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Home</h1>')
  end

  test 'unauthenticated should not match the given routes when there is a user logged in with the given scope' do
    set_unauthenticated_constraint(:user)
    login_as(@user)
    get root_path

    assert response.body.include?('<h1>Dashboard</h1>')
  end
end
