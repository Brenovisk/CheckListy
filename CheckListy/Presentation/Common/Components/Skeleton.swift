import SwiftUI

struct Skeleton: View {

    @State private var isAnimating = false
    var hasRecents: Bool = false
    var hasSegment: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            if hasRecents {
                Section(header: recentsHeaderSection) {
                    cards(listMode: .grid)
                        .scrollHorizontal(padding: 16)
                        .collapse(isCollapsed: false)
                }
                .padding(.bottom, false ? 0 : 16)
            }

            if hasSegment {
                SegmentPicker(
                    selectedIndex: Binding.constant(0),
                    segments: segments
                )
                .padding(.bottom, 24)
                .padding(.top, 8)
            }

            cards(listMode: .list)
                .padding(.horizontal, 16)
        }
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(
            Animation.easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .redacted(reason: .placeholder)
        .onAppear {
            isAnimating = true
        }
    }

}

// MARK: computed Variables
extension Skeleton {

    private func cards(listMode: ListMode) -> some View {
        ForEach(0 ..< 5, id: \.self) { _ in
            ListCard(
                list: ListModel(
                    name: "Placeholder",
                    color: "gray-app",
                    icon: "checkmark.circle"
                ),
                mode: Binding.constant(listMode)
            )
        }
    }

    private var recentsHeaderSection: some View {
        HeaderSection(
            section: SectionModel<String>(name: "Placeholder", items: []),
            icon: IconsHelper.clock.rawValue,
            enableAdd: false
        ).onCollapse { _ in }
            .padding(.horizontal, 16)
    }

    private var segments: [SegmentCustom] {
        [
            SegmentCustom(
                title: "Todas",
                icon: IconsHelper.listBullet.value,
                color: Color(.blueApp),
                number: .zero
            ) {},
            SegmentCustom(
                title: "Favoritos",
                icon: IconsHelper.star.value,
                color: Color(.yellowApp),
                number: .zero
            ) {},
            SegmentCustom(
                title: "Incompletas",
                icon: IconsHelper.xmark.value,
                color: Color(.redApp),
                number: .zero
            ) {},
            SegmentCustom(
                title: "Completas",
                icon: IconsHelper.checkmark.value,
                color: .accentColor,
                number: .zero
            ) {}
        ]
    }
}

struct ContentViewSkeletonListView: View {

    var body: some View {
        Skeleton()
    }

}

#Preview {
    ContentViewSkeletonListView()
}
