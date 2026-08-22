//
//  Copyright © Reddit. All rights reserved.
//

import CoreStack
import CoreStack_SwiftUI
import Palette_RedditPalette
import RedditSliceKit
import RedditSliceKit_RPLHostableViews
import RPLComponents
import RPLComponents_SwiftUI
import RPLIcons_Assets
import SliceKit
import SwiftUI

struct ShoppingIntelTabItem: RPLTabItem {
  let identifier: String
  let displayName: String
  let badgeState: RPLTabBadgeState = .hidden
  let leadingImage: RPLTabLeadingImage = .hidden
}

struct ShoppingIntelSearchHeaderView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelSearchHeaderPayload
  let onBack: @MainActor @Sendable () -> Void

  var body: some View {
    ShoppingIntelSearchHeaderContent(payload: payload, onBack: onBack)
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    guard let other = other as? Self else { return false }
    return payload == other.payload
  }
}

private struct ShoppingIntelSearchHeaderContent: View {
  @StateObject private var viewModel: CoreStackViewModel<ShoppingIntelHeaderFeature>
  @Environment(\.redditTheme) private var theme: RPLTheme

  init(payload: ShoppingIntelSearchHeaderPayload, onBack: @escaping @MainActor @Sendable () -> Void) {
    _viewModel = StateObject(wrappedValue: CoreStackViewModel(
      initialState: .init(payload: payload),
      dependencies: ShoppingIntelHeaderFeature.Dependencies(dismiss: onBack)
    ))
  }

  var body: some View {
    HStack(spacing: 12) {
      RPLButton.viewRepresentable(
        content: .init(
          appearance: .plain,
          configuration: .icon(
            imageResource: Assets.rpl.iconArrowBack24Outline,
            accessibilityLabel: ShoppingIntelResources.string("back", fallback: "Back"),
            size: .large
          ),
          accessibilityIdentifier: "shopping-intel.back",
          accessibilityLabel: ShoppingIntelResources.string("back", fallback: "Back")
        ),
        behaviors: .init(didTap: { _ in viewModel.send(.tappedBack) })
      )
      .fixedSize()

      HStack(spacing: 10) {
        Image(resource: Assets.rpl.iconSearchHighlightOutline)
          .resizable()
          .frame(width: 18, height: 18)
          .accessibilityHidden(true)
        Text(viewModel.state.payload.query)
          .font(Font(theme.font.rpl.semantic.body1))
          .foregroundStyle(Color(theme.color.rpl.neutral.contentStrong))
          .lineLimit(1)
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 12)
      .frame(height: 48)
      .background(Color(theme.color.rpl.neutral.backgroundContainer), in: Capsule())
      .shadow(color: Color(theme.color.rpl.neutral.content).opacity(0.12), radius: 4, y: 1)
      .accessibilityElement(children: .combine)
      .accessibilityLabel(viewModel.state.payload.query)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color(theme.color.rpl.neutral.background))
  }
}

struct ShoppingIntelTabsView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelTabsPayload

  var body: some View {
    ShoppingIntelTabsContent(payload: payload)
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    (other as? Self)?.payload == payload
  }
}

private struct ShoppingIntelTabsContent: View {
  @StateObject private var viewModel: CoreStackViewModel<ShoppingIntelTabsFeature>

  init(payload: ShoppingIntelTabsPayload) {
    _viewModel = StateObject(wrappedValue: CoreStackViewModel(
      initialState: .init(payload: payload, selectedID: payload.selectedID)
    ))
  }

  var body: some View {
    RPLTabGroup.viewRepresentable(
      content: .init(configuration: .init(
        items: viewModel.state.payload.tabs.map {
          ShoppingIntelTabItem(identifier: $0.id, displayName: $0.title)
        },
        selectedItemIdentifier: viewModel.state.selectedID,
        style: .bottomBorder,
        layout: .hug,
        size: .small
      )),
      behaviors: .init(didTapTab: { viewModel.send(.selected($0.identifier)) })
    )
    .fixedSize(horizontal: false, vertical: true)
    .accessibilityIdentifier("shopping-intel.result-tabs")
  }
}

struct ShoppingIntelSummaryView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelSummaryPayload

  var body: some View {
    ShoppingIntelDisplayHost(payload: payload) { payload in
      ShoppingIntelSummaryContent(payload: payload)
    }
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    (other as? Self)?.payload == payload
  }
}

private struct ShoppingIntelSummaryContent: View {
  let payload: ShoppingIntelSummaryPayload
  @Environment(\.redditTheme) private var theme: RPLTheme

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 4) {
        Image(resource: Assets.rpl.iconAiOutline)
          .resizable()
          .frame(width: 16, height: 16)
          .accessibilityHidden(true)
        Text(payload.title)
          .font(Font(theme.font.rpl.semantic.headline))
      }
      Text(payload.body)
        .font(Font(theme.font.rpl.semantic.body1))
        .foregroundStyle(Color(theme.color.rpl.neutral.contentStrong))
        .padding(.leading, 18)
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
    .background(Color(theme.color.rpl.neutral.background))
    .accessibilityElement(children: .combine)
  }
}

struct ShoppingIntelProductCardsView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelProductCardsPayload

  var body: some View {
    ShoppingIntelDisplayHost(payload: payload) { payload in
      ShoppingIntelProductCardsContent(payload: payload)
    }
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    (other as? Self)?.payload == payload
  }
}

private struct ShoppingIntelProductCardsContent: View {
  let payload: ShoppingIntelProductCardsPayload
  @Environment(\.redditTheme) private var theme: RPLTheme

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      ForEach(payload.products) { product in
        VStack(alignment: .leading, spacing: 8) {
          Group {
            if let image = ShoppingIntelResources.image(named: product.imageName) {
              Image(uiImage: image).resizable()
            } else {
              Color(theme.color.rpl.neutral.backgroundContainer)
            }
          }
          .scaledToFit()
          .aspectRatio(1, contentMode: .fit)
          .background(Color(theme.color.rpl.neutral.background))
          .clipShape(RoundedRectangle(cornerRadius: 21))
          .overlay(
            RoundedRectangle(cornerRadius: 21)
              .stroke(Color(theme.color.rpl.neutral.borderWeak), lineWidth: 1)
          )
          .accessibilityHidden(true)

          Text(product.title)
            .font(Font(theme.font.rpl.semantic.headline))
            .underline(pattern: .dot)
            .lineLimit(1)
          Text(product.mentions)
            .font(Font(theme.font.rpl.semantic.caption1))
            .foregroundStyle(Color(theme.color.rpl.neutral.contentWeak))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
    .background(Color(theme.color.rpl.neutral.background))
  }
}

struct ShoppingIntelExpandView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelExpandPayload

  var body: some View {
    ShoppingIntelExpandContent(payload: payload)
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    (other as? Self)?.payload == payload
  }
}

private struct ShoppingIntelExpandContent: View {
  @StateObject private var viewModel: CoreStackViewModel<ShoppingIntelExpandFeature>
  @Environment(\.redditTheme) private var theme: RPLTheme

  init(payload: ShoppingIntelExpandPayload) {
    _viewModel = StateObject(wrappedValue: CoreStackViewModel(
      initialState: .init(payload: payload)
    ))
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if viewModel.state.isExpanded {
        Text(viewModel.state.payload.expandedHeading)
          .font(Font(theme.font.rpl.semantic.headline))
        Text(viewModel.state.payload.expandedBody)
          .font(Font(theme.font.rpl.semantic.body2))
      }
      RPLButton.viewRepresentable(
        content: .init(
          appearance: .secondary,
          configuration: .text(
            title: viewModel.state.isExpanded
              ? viewModel.state.payload.expandedTitle
              : viewModel.state.payload.collapsedTitle,
            size: .medium
          ),
          accessibilityIdentifier: "shopping-intel.expand",
          accessibilityLabel: viewModel.state.isExpanded
            ? viewModel.state.payload.expandedTitle
            : viewModel.state.payload.collapsedTitle
        ),
        behaviors: .init(didTap: { _ in viewModel.send(.tapped) })
      )
      .frame(maxWidth: .infinity)
    }
    .padding(16)
    .background(Color(theme.color.rpl.neutral.background))
  }
}

struct ShoppingIntelPostView: HostedListItemRepresentable, ImplicitAnimationSuppressing {
  let differenceIdentifier: String
  let payload: ShoppingIntelPostPayload
  let onOpen: @MainActor @Sendable (String) -> Void

  var body: some View {
    ShoppingIntelDisplayHost(payload: payload) { payload in
      ShoppingIntelPostContent(payload: payload, onOpen: onOpen)
    }
  }

  nonisolated func isContentEqual(to other: any ContentEquatableListItem) -> Bool {
    (other as? Self)?.payload == payload
  }
}

private struct ShoppingIntelPostContent: View {
  let payload: ShoppingIntelPostPayload
  let onOpen: @MainActor @Sendable (String) -> Void
  @Environment(\.redditTheme) private var theme: RPLTheme

  var body: some View {
    Button {
      onOpen(payload.id)
    } label: {
      HStack(alignment: .top, spacing: 8) {
        VStack(alignment: .leading, spacing: 5) {
          Text("\(payload.community) · \(payload.age)")
            .font(Font(theme.font.rpl.semantic.caption1))
            .foregroundStyle(Color(theme.color.rpl.neutral.contentWeak))
          Text(payload.title)
            .font(Font(theme.font.rpl.semantic.body2))
            .foregroundStyle(Color(theme.color.rpl.neutral.contentStrong))
            .lineLimit(2)
          HStack(spacing: 10) {
            HStack(spacing: 3) {
              Image(resource: Assets.rpl.iconUpvote12Outline)
                .resizable()
                .frame(width: 12, height: 12)
              Text(payload.votes)
            }
            HStack(spacing: 3) {
              Image(resource: Assets.rpl.iconComment12Outline)
                .resizable()
                .frame(width: 12, height: 12)
              Text(payload.comments)
            }
          }
          .font(Font(theme.font.rpl.semantic.caption1))
          .foregroundStyle(Color(theme.color.rpl.neutral.contentWeak))
        }
        Spacer(minLength: 0)
        if let imageName = payload.imageName,
           let image = ShoppingIntelResources.image(named: imageName) {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityHidden(true)
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, minHeight: 78, alignment: .leading)
      .background(Color(theme.color.rpl.neutral.background))
    }
    .buttonStyle(.plain)
    .accessibilityIdentifier("shopping-intel.post.\(payload.id)")
    .overlay(alignment: .top) {
      RPLDivider.viewRepresentable(content: .init(
        appearance: .weak,
        configuration: .init(
          orientationType: .horizontal,
          widthType: .full,
          verticalPaddingType: .noPadding
        )
      ))
      .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct ShoppingIntelDisplayHost<Payload: Sendable, Content: View>: View {
  @StateObject private var viewModel: CoreStackViewModel<ShoppingIntelDisplayFeature<Payload>>
  private let content: (Payload) -> Content

  init(payload: Payload, @ViewBuilder content: @escaping (Payload) -> Content) {
    _viewModel = StateObject(wrappedValue: CoreStackViewModel(
      initialState: .init(payload: payload)
    ))
    self.content = content
  }

  var body: some View {
    content(viewModel.state.payload)
  }
}
