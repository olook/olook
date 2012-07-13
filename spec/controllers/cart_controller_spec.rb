# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartController do
  it "should erase freight when call any action"
  
  context "when show" do
    it "should assign default bonus value"
    it "should assign bonus value for user"
    it "should render show view"
  end
  
  context "when destroy" do
    it "should remove cart in database"
    it "should reset session params"
    it "should set flash notice"
    it "should redirect to cart"
  end

  context "when update" do
    it "should remove item"
    
    context "when item removed and respond for html" do
      it "should redirect to cart"
      it "should set flash notice"
    end
    
    it "should head is ok when item removed and respond for js"

    context "when item is not removed and respond for html" do
      it "should redirect to cart"
      it "should set flash notice"
    end

    it "should head is not when item is not removed and respond for js"
  end

  context "when add item" do
    it "should assign variant"
    
    context "when no has valid variant" do
      it "should render error in response for js"
      it "should render back in response for html"
      it "shoudl set flash notice in response for html"
    end
    
    context "when has valid variant" do
      it "should add item"

      context "when item added and respond for html" do
        it "should redirect to cart"
        it "should set flash notice"
      end

      it "should render create when item added and respond for js"

      context "when item is not added and respond for html" do
        it "should redirect to cart"
        it "should set flash notice"
        it "should set flash notice with gift items"
      end

      context "when item is not added and respond for js" do
        it "should render error"
        it "should set flash notice"
        it "should set flash notice with gift items"
      end
    end
  end
  
  
  context "when update gift wrap" do
    it "should update session"
    it "should response true for json"
  end

  context "when update coupon" do
    it "should redirect to cart"
    context "when has valid coupon" do
      it "should set flash"
      it "should set session"
    end
    context "when has invalid coupon" do
      it "should set flash"
      it "should set session"
    end
    context "when has expired coupon" do
      it "should set flash"
      it "should set session"
    end
  end
  
  context "when remove coupon" do
    it "should redirect to cart"
    it "should set session"
    it "should set flash when has valid coupon in session"
    it "should set flash when has invalid coupon in session"
  end

  context "when remove credits" do
    it "should redirect to cart"
    it "should set flash when has invalid credits in cart"
    it "should set session when has credits in cart"
    it "should set flash when has credits in cart"
  end
  
  context "when update credits" do
    it "should redirect to cart"
    it "should set flash when user no has sufficient credit"
    
    context "and has sufficient credit" do
      it "should set session"
      it "should set flash"
      it "should set flash for max value"
    end
  end
end

