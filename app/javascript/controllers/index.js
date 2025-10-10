// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

// Import all controllers explicitly
import CarouselController from "./carousel_controller"
import CartPageController from "./cart_page_controller"
import CheckoutPaymentController from "./checkout_payment_controller"
import CollapseController from "./collapse_controller"
import DrawerController from "./drawer_controller"
import EventPreviewController from "./event_preview_controller"
import EventSliderController from "./event_slider_controller"
import HelloController from "./hello_controller"
import ImageOptimizationController from "./image_optimization_controller"
import LightboxController from "./lightbox_controller"
import LocaleSelectorController from "./locale_selector_controller"
import MobileCarouselController from "./mobile_carousel_controller"
import MobileFilterController from "./mobile_filter_controller"
import PropertyValuesController from "./property_values_controller"
import RangeSliderController from "./range_slider_controller"
import SearchController from "./search_controller"
import ThemeSwitcherController from "./theme_switcher_controller"
import TopBarController from "./top_bar_controller"

// Register all controllers
application.register("carousel", CarouselController)
application.register("cart-page", CartPageController)
application.register("checkout-payment", CheckoutPaymentController)
application.register("collapse", CollapseController)
application.register("drawer", DrawerController)
application.register("event-preview", EventPreviewController)
application.register("event-slider", EventSliderController)
application.register("hello", HelloController)
application.register("image-optimization", ImageOptimizationController)
application.register("lightbox", LightboxController)
application.register("locale-selector", LocaleSelectorController)
application.register("mobile-carousel", MobileCarouselController)
application.register("mobile-filter", MobileFilterController)
application.register("property-values", PropertyValuesController)
application.register("range-slider", RangeSliderController)
application.register("search", SearchController)
application.register("theme-switcher", ThemeSwitcherController)
application.register("top-bar", TopBarController)
