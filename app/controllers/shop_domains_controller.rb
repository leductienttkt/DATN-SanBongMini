class ShopDomainsController < ApplicationController
  before_action :load_shop, only: [:create, :destroy]
  before_action :load_shop_domain, only: :update
  before_action :load_domain_by_param
  before_action :authenticate_user!

  def index
    @shop_domains = if params[:approved].present?
      @choosen_domain.shop_domains.includes(shop: :users).approved
    else
      @choosen_domain.shop_domains.includes(shop: :users).pending
    end
  end

  def new
    @shops = current_user.shops.page(params[:page]).per Settings.common.per_page
  end

  def create
    if params[:status].present?
      shop_domain = ShopDomain.new shop_id: @shop.id,
        domain_id: @choosen_domain.id, status: params[:status]
    else
      shop_domain = ShopDomain.new shop_id: @shop.id, domain_id: @choosen_domain.id
    end
    check_save_shop_domain shop_domain
    redirect_to :back
  end

  def destroy
    ShopDomain.destroy_all domain_id: params[:domain_id], shop_id: @shop.id
    AddShopProductToDomainService.new(@shop, @choosen_domain).delete
    redirect_to :back
  end

  def update
    if @shop_domain.update_attributes status: params[:status]
      if @shop_domain.approved?
        shop = @shop_domain.shop
        domain = @shop_domain.domain
        AddShopProductToDomainService.new(shop, domain).add
        @shop_domain.create_event_request_shop @domain.owner, @shop_domain
        @shop_domain.create_event_request_shop @shop_domain.shop.owner_id, @shop_domain
        flash[:success] = t "add_shop_domain_success"
      elsif params[:status] == ShopDomain.statuses.key(2)
        @shop_domain.create_event_request_shop @shop_domain.shop.owner_id, @shop_domain
      end
      redirect_to :back
    end
  end

  private
  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop.present?
      redirect_to :back
      flash[:danger] = t "can_not_load_shop"
    end
  end

  def load_shop_domain
    @shop_domain = ShopDomain.find_by id: params[:id]
    unless @shop_domain.present?
      redirect_to :back
      flash[:danger] = t "can_not_load_shop"
    end
  end

  def check_save_shop_domain shop_domain
    if shop_domain.save
      shop_domain.create_event_request_shop @choosen_domain.owner, shop_domain
      sent_notification_domain_manager @choosen_domain, shop_domain
      if shop_domain.approved?
        AddShopProductToDomainService.new(@shop, @choosen_domain).add
      end
    else
      flash[:danger] = t "can_not_add_shop"
    end
  end

  def sent_notification_domain_manager domain, shop_domain
    domain.user_domains.each do |user_domain|
      if user_domain.manager? && user_domain.user_id != @choosen_domain.owner
        shop_domain.create_event_request_shop user_domain.user_id, shop_domain
      end
    end
  end
end
