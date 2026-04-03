/*--------------------------------------------------------------------------------------------------------------------------
    File: AppImages.swift
  Author: Kevin Messina
 Created: 11/11/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

// MARK: - *** APP IMAGES ***
/// SF Symbols names for system images in your app.
///
/// This is the basic set of App Images used across many standard apps.
/// To EXTEND this list, add a new section in your code by:
///
///     extension AppImages {
///         static let line = AppImages(rawValue: "line")
///     }
///
/// - Returns: String name of SF Symbol to be used in Image(systemName: xx)
struct AppImages: RawRepresentable {
    var rawValue: SFSymbol
    
    /* App Logo / Launch Screen */
    static let logo = AppImages(rawValue: "AppLogo").rawValue
    
    /* App Generic */
    
    
    static let angle = AppImages(rawValue: "angle").rawValue // 􁑡
    static let about = AppImages(rawValue: "character.book.closed").rawValue // 􀫕
    static let add = AppImages(rawValue: "plus.app").rawValue // 􀑍
    static let addressBook = AppImages(rawValue: "character.book.closed.fill").rawValue // 􀫖
    static let arrow_Left = AppImages(rawValue: "arrowshape.left.fill").rawValue //􁉅
    static let arrow_Left_Square = AppImages(rawValue: "arrow.left.square.fill").rawValue // 􀄋
    static let arrow_Right = AppImages(rawValue: "arrowshape.right.fill").rawValue // 􁉃
    static let arrow_Right_Square = AppImages(rawValue: "arrow.right.square.fill").rawValue // 􀄍
    static let arrow_Up = AppImages(rawValue: "arrowshape.up.fill").rawValue //􁾩
    static let arrow_Up_Square = AppImages(rawValue: "arrow.up.square.fill").rawValue //􀄇
    static let arrow_Down = AppImages(rawValue: "arrowshape.down.fill").rawValue //􁾭
    static let arrow_Down_Square = AppImages(rawValue: "arrow.down.square.fill").rawValue //􀄉
    static let backArrow = AppImages(rawValue: "arrow.backward").rawValue // 􀰌
    static let buildings = AppImages(rawValue: "building.2.fill").rawValue // 􀝓
    static let building_Store = AppImages(rawValue: "storefront").rawValue // 􁽇
    static let buy = AppImages(rawValue: "cart.badge.plus").rawValue // 􀍫
    static let calendar = AppImages(rawValue: "calendar").rawValue // 􀉉
    static let calendar_Expiring = AppImages(rawValue: "calendar.badge.clock").rawValue //􀧞
    static let calendar_Expired = AppImages(rawValue: "calendar.badge.exclamationmark").rawValue //􀮝
    static let camera = AppImages(rawValue: "camera").rawValue //􀌞
    static let cancel = AppImages(rawValue: "nosign").rawValue //􀍼
    static let cart = AppImages(rawValue: "cart").rawValue // 􀍩
    static let checkmark = AppImages(rawValue: "checkmark").rawValue // 􀆅
    static let checkBox_On = AppImages(rawValue: "checkmark.square").rawValue // 􀃲
    static let checkBox_Off = AppImages(rawValue: "square").rawValue // 􀂒
    static let checkBox_X = AppImages(rawValue: "xmark.square").rawValue // 􀃰
    static let clearAll = AppImages(rawValue: "Clear_All").rawValue //
    static let close = AppImages(rawValue: "x.circle").rawValue // 􀀲
    static let contacts = AppImages(rawValue: "person.crop.square.filled.and.at.rectangle").rawValue // 􀦎
    static let compass = AppImages(rawValue: "safari").rawValue // 􀎬
    static let contactUs = AppImages(rawValue: "envelope.badge.person.crop").rawValue // 􁷻
    static let copyright = AppImages(rawValue: "c.circle").rawValue // 􀀈
    static let critical = AppImages(rawValue: "exclamationmark.octagon.fill").rawValue // 􀘰
    static let curve = AppImages(rawValue: "beziercurve").rawValue //􀜢
    static let dashboard = AppImages(rawValue: "doc.richtext").rawValue // 􀉅
    static let developer = AppImages(rawValue: "person.and.background.striped.horizontal").rawValue // 􁠃
    static let Disclosure_Rt = AppImages(rawValue: "chevron.right").rawValue // 􀆊
    static let Disclosure_Lt = AppImages(rawValue: "chevron.left").rawValue // 􀆉
    static let Disclosure_Up = AppImages(rawValue: "chevron.up").rawValue // 􀆇
    static let Disclosure_Dn = AppImages(rawValue: "chevron.down").rawValue // 􀆈
    static let database = AppImages(rawValue: "filemenu.and.selection").rawValue // 􀱢
    static let docs = AppImages(rawValue: "book.pages").rawValue // 􁜾
    static let doc_Item = AppImages(rawValue: "doc.richtext").rawValue // 􀉅
    static let doc_Elipse = AppImages(rawValue: "doc.badge.ellipsis").rawValue // 􀩴
    static let doc_Question = AppImages(rawValue: "doc.questionmark").rawValue // 􂇲
    static let doc_Scan = AppImages(rawValue: "document.viewfinder").rawValue //􀎾
    static let doc_Text = AppImages(rawValue: "doc.text").rawValue // 􀈿
    static let dollar = AppImages(rawValue: "dollarsign.circle").rawValue // 􀖗
    static let dollar_Sign = AppImages(rawValue: "dollarsign").rawValue // 􁎢
    static let edit = AppImages(rawValue: "square.and.pencil").rawValue // 􀈎
    static let email = AppImages(rawValue: "envelope.fill").rawValue // 􀍖
    static let entry = AppImages(rawValue: "calendar.badge.clock").rawValue // 􀧞
    static let expired = AppImages(rawValue: "calendar.badge.exclamationmark").rawValue // 􀮝
    static let expiring = AppImages(rawValue: "calendar.badge.clock").rawValue // 􀧞
    static let error = AppImages(rawValue: "exclamationmark.circle.fill").rawValue // 􀁟
    static let favoriteNo = AppImages(rawValue: "heart").rawValue // 􀊴
    static let favoriteYes = AppImages(rawValue: "heart.fill").rawValue // 􀊵
    static let favoriteSlash = AppImages(rawValue: "heart.slash").rawValue // 􀊶
    static let flowchart = AppImages(rawValue: "flowchart.slash").rawValue // 􀐕
    static let folder = AppImages(rawValue: "folder").rawValue // 􀈕
    static let formula = AppImages(rawValue: "x.squareroot").rawValue // 􀓪
    static let help = AppImages(rawValue: "info.circle").rawValue // 􀅴
    static let helpBubble = AppImages(rawValue: "info.bubble").rawValue // 􁌴
    static let helpMenu = AppImages(rawValue: "info.square").rawValue // 􁊇
    static let hidePassword = AppImages(rawValue: "eye.slash").rawValue // 􀋯
    static let idCard = AppImages(rawValue: "person.text.rectangle").rawValue // 􀿒
    static let info = AppImages(rawValue: "info.circle").rawValue // 􀅴
    static let infoFilled = AppImages(rawValue: "info.triangle.fill").rawValue // 􂹪
    static let info_i = AppImages(rawValue: "info").rawValue // 􀅳
    static let inventory = AppImages(rawValue: "archivebox.fill").rawValue // 􀈮
    static let key = AppImages(rawValue: "key.horizontal.fill").rawValue // 􁠲
    static let keyboard_Show = AppImages(rawValue: "keyboard").rawValue // 􀇳
    static let keyboard_Hide = AppImages(rawValue: "keyboard.chevron.compact.down").rawValue // 􀓖
    static let keyboard_Minus = AppImages(rawValue: "minus.forwardslash.plus").rawValue // 􀅻
    static let lightbulb_On = AppImages(rawValue: "lightbulb.max.fill").rawValue // 􁷙
    static let lightbulb_Off = AppImages(rawValue: "lightbulb.slash").rawValue // 􀞃
    static let link = AppImages(rawValue: "link").rawValue // 􀉣
    static let list = AppImages(rawValue: "list.bullet.rectangle").rawValue
    static let location = AppImages(rawValue: "mappin.and.ellipse").rawValue // 􀎫
    static let map = AppImages(rawValue: "map").rawValue // 􀙊
    static let math_Minus = AppImages(rawValue: "minus").rawValue // 􀅽
    static let math_Plus = AppImages(rawValue: "plus").rawValue // 􀅼
    static let math_Multiply = AppImages(rawValue: "multiply").rawValue // 􀅾
    static let math_Divide = AppImages(rawValue: "divide").rawValue // 􀅿
    static let math_SquareRoot = AppImages(rawValue: "squareroot").rawValue // 􂲯
    static let measure = AppImages(rawValue: "ruler.fill").rawValue // 􀟁
    static let menu = AppImages(rawValue: "line.3.horizontal").rawValue // 􀌇
    static let message = AppImages(rawValue: "message").rawValue // 􀌤
    static let messaging = AppImages(rawValue: "message.fill").rawValue // 􀌥
    static let mobilePhone = AppImages(rawValue: "candybarphone").rawValue // 􀪳
    static let noSign = AppImages(rawValue: "nosign").rawValue // 􀍼
    static let note = AppImages(rawValue: "note").rawValue // 􀧵
    static let noteText = AppImages(rawValue: "note.text").rawValue // 􀓕
    static let params = AppImages(rawValue: "rectangle.and.pencil.and.ellipsis").rawValue // 􀈏
    static let person = AppImages(rawValue: "person.fill").rawValue // 􀉪
    static let person_Rectangle = AppImages(rawValue: "person.crop.rectangle.stack").rawValue // 􀏻
    static let phone = AppImages(rawValue: "phone.fill").rawValue // 􀌿
    static let photo = AppImages(rawValue: "photo").rawValue // 􀏅
    static let photo_Issue = AppImages(rawValue: "photo.badge.exclamationmark").rawValue // 􂪥
    static let photo_Stack = AppImages(rawValue: "photo.stack").rawValue // 􀏯
    static let photos = AppImages(rawValue: "photo.on.rectangle.angled").rawValue // 􀣵
    static let pointTouch = AppImages(rawValue: "hand.point.up.fill").rawValue // 􀤺
    static let printer = AppImages(rawValue: "printer").rawValue // 􀎚
    static let purchase = AppImages(rawValue: "cart").rawValue // 􀍩
    static let questionMark = AppImages(rawValue: "questionmark").rawValue // ?
    static let receipt_none = AppImages(rawValue: "receipt").rawValue //􂷼
    static let receipt = AppImages(rawValue: "receipt.fill").rawValue //􂷽
    static let reference = AppImages(rawValue: "books.vertical.fill").rawValue // 􀬓
    static let refresh = AppImages(rawValue: "arrow.clockwise").rawValue // 􀅈
    static let reorder = AppImages(rawValue: "arrow.up.and.down.text.horizontal").rawValue // 􀵬
    static let reorderSave = AppImages(rawValue: "text.badge.checkmark").rawValue // 􀋺
    static let replace = AppImages(rawValue: "rectangle.2.swap").rawValue // 􁁀
    static let resize = AppImages(rawValue: "square.resize").rawValue // 􂁟
    static let resize_Up = AppImages(rawValue: "square.resize.up").rawValue // 􁺟
    static let resize_Down = AppImages(rawValue: "square.resize.down").rawValue // 􁺠
    static let rotate_left = AppImages(rawValue: "rotate.left").rawValue // 􀎮
    static let rotate_right = AppImages(rawValue: "rotate.right").rawValue // 􀎰
    static let scan_barcode = AppImages(rawValue: "barcode.viewfinder").rawValue // 􀎺
    static let scan_camera = AppImages(rawValue: "camera.viewfinder").rawValue // 􀎼
    static let scan_doc = AppImages(rawValue: "document.viewfinder").rawValue // 􀎾
    static let scan_docFilled = AppImages(rawValue: "document.viewfinder.fill").rawValue // 􀡢
    static let scan_dot = AppImages(rawValue: "dot.viewfinder").rawValue // 􁇝
    static let scan_QRcode = AppImages(rawValue: "qrcode.viewfinder").rawValue // 􀎻
    static let scanner = AppImages(rawValue: "scanner").rawValue // 􀪊
    static let search = AppImages(rawValue: "rectangle.and.text.magnifyingglass").rawValue // 􀍟
    static let sell = AppImages(rawValue: "cart.fill.badge.minus").rawValue // 􀍮
    static let settings = AppImages(rawValue: "gear").rawValue // 􀍟
    static let settingsAdj = AppImages(rawValue: "gear.badge.questionmark").rawValue // 􁅨
    static let share = AppImages(rawValue: "square.and.arrow.up").rawValue // 􀈂
    static let showPassword = AppImages(rawValue: "eye").rawValue // 􀋭
    static let sliders = AppImages(rawValue: "slider.horizontal.3").rawValue // 􀌆
    static let specs = AppImages(rawValue: "list.number").rawValue // 􀋴
    static let star = AppImages(rawValue: "star").rawValue // 􀋂
    static let status = AppImages(rawValue: "questionmark.app.dashed").rawValue // 􀿪
    static let stop = AppImages(rawValue: "exclamationmark.octagon").rawValue // 􀘯
    static let thumbnail_yes = AppImages(rawValue: "hand.thumbsup.fill").rawValue // 􀞠
    static let thumbnail_no = AppImages(rawValue: "hand.thumbsup").rawValue // 􀞠
    static let table = AppImages(rawValue: "tablecells").rawValue // 􀏣
    static let tableCells = AppImages(rawValue: "tablecells.badge.ellipsis").rawValue // 􀏥
    static let tip = AppImages(rawValue: "exclamationmark.shield.fill").rawValue // 􀞠
    static let txtFld_Next = AppImages(rawValue: "dock.arrow.down.rectangle").rawValue // 􀣿
    static let txtFld_Prev = AppImages(rawValue: "dock.arrow.up.rectangle").rawValue // 􀣾
    static let txtFld_list = AppImages(rawValue: "list.bullet.rectangle.fill").rawValue // 􀺿
    static let txtFld_date = AppImages(rawValue: "calendar").rawValue // 􀉉
    static let txtFld_pay = AppImages(rawValue: "creditcard.fill").rawValue // 􀍰
    static let txtFld_item = AppImages(rawValue: "puzzlepiece.fill").rawValue // 􀤛
    static let theme = AppImages(rawValue: "swatchpalette").rawValue // 􁙧
    static let trash = AppImages(rawValue: "trash").rawValue // 􀈑
    static let undo = AppImages(rawValue: "arrow.uturn.backward").rawValue // 􀱍
    static let warning = AppImages(rawValue: "exclamationmark.triangle").rawValue // 􀇾
    static let warningFilled = AppImages(rawValue: "exclamationmark.triangle.fill").rawValue // 􀇿
    static let website = AppImages(rawValue: "globe").rawValue // 􀆪
    static let whatsNew = AppImages(rawValue: "book.circle").rawValue // 􀉜
    static let xMark_Landscape = AppImages(rawValue: "xmark.rectangle").rawValue // 􀏍
    static let xMark_Portrait = AppImages(rawValue: "xmark.rectangle.portrait").rawValue // 􀡰
    static let xMark_Square = AppImages(rawValue: "xmark.app").rawValue // 􀺾
    static let xMark = AppImages(rawValue: "xmark").rawValue // 􀆄
}
