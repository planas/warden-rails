class DummyController < ApplicationController
  # Root for unauthenticated users
  def home
  end

  # Root for authenticated users
  def dashboard
  end
end
