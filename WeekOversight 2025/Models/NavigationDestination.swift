enum NavigationDestination: Hashable, Codable {
    case clientManagement
    case clientGroupDetail(ClientGroup)
    case weekOversight(WeekOversight)
    case dayOversight(DayOversight)
    case welcome
} 