class UserDomainsController < ApplicationController
  before_action :load_data
  before_action :load_domain_by_param
  before_action :load_user_domain, only: :update
  before_action :authenticate_user!

  def index
    @users = @choosen_domain.users
  end

  def new
    unless @choosen_domain
      flash[:danger] = t "can_not_load_domain"
      redirect_to :back
    end
    @users = User.by_active.page(params[:page]).per Settings.common.per_page
  end

  def create
    if @user
      user_domain = UserDomain.new user_id: @user.id,
        domain_id: @choosen_domain.id, role: :member
      save_user_domain user_domain
    else
      flash[:danger] = t "can_not_find_user"
    end
    redirect_to :back
  end

  def update
    if @user_domain.update_attributes role: params[:role]
      flash[:success] = t "manage_domain.add_manager_successfully"
    else
      flash[:danger] = t "manage_domain.add_manager_faild"
    end
    @user_domain.create_event_add_manager_domain @user_domain.user_id
    redirect_to :back
  end

  def destroy
    UserDomain.destroy_all domain_id: @choosen_domain.id, user_id: @user.id
    flash[:success] = t "leave_domain_success" if params[:leave_domain].present?
    flash[:success] = t "delete_domain" if params[:delete_user_domain].present?
    if current_user.domains.include? @choosen_domain
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  private
  def load_data
    if params[:user_id]
      @user = User.find_by id: params[:user_id]
    elsif params[:email]
      @user = User.find_by email: params[:email]
    end
    return unless @user
    @products = @user.products
    @shops = @user.shops
  end

  def save_user_domain user_domain
    if user_domain.save
      if @domain.owner? current_user.id
        user_domain.create_event_add_user_domain @user.id
      elsif current_user.is_user? @user.id
        user_domain.create_event_add_user_domain @domain.owner
        sent_notification_domain_manager @domain
      end
      flash[:success] = t "join_domain_success" if params[:join_domain].present?
      flash[:success] = t "add_domain" if params[:add_domain].present?
    else
      flash[:danger] = t "can_not_add_account"
    end
  end

  def load_user_domain
    @user_domain = UserDomain.find_by id: params[:id]
    unless @user_domain.present?
      redirect_to :back
      flash[:danger] = t "can_not_load_user"
    end
  end

  def sent_notification_domain_manager domain
    domain.user_domains.each do |usr_domain|
      if usr_domain.manager?
        usr_domain.create_event_add_user_domain usr_domain.user_id
      end
    end
  end
end
