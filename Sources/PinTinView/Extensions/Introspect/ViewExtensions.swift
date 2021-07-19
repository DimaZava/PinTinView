import SwiftUI
import UIKit

extension View {
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
}

extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        return inject(UIKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `UITableViewCell` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectTableViewCell(customize: @escaping (UITableViewCell) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }

    /// Finds a `UITextView` from a `SwiftUI.TextEditor`
    public func introspectTextView(customize: @escaping (UITextView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
