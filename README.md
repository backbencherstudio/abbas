# Acting Academy App

## Project Overview


## Full Project Structure (MVVM Pattern)
1. Core & Services (/core or /cors)
Global configurations and low-level infrastructure.

lib/
└── core/
    ├── constants/           # api_endpoints.dart
    ├── di/                  # injection.dart (Dependency Injection)
    ├── network/             # api_error_handle.dart, network.dart
    ├── routes/              # app_routes.dart, route_names.dart
    ├── services/            # dio_client.dart, socket_service.dart, storage.dart
    ├── theme/               # app_theme.dart, app_colors.dart
    └── utils/               # app_utils.dart
    
2. Global Presentation Layer (/presentation)
This is where your shared logic and the "brain" of your UI lives.

lib/
└── presentation/
    ├── viewmodels/          # Logic for updating the UI
    │   ├── auth/            # login_viewmodel.dart, register_viewmodel.dart, etc.
    │   ├── community/       # post_viewmodel.dart
    │   ├── course/          # course_viewmodel.dart
    │   ├── home/            # home_viewmodel.dart
    │   ├── onboarding/      # onboarding_viewmodel.dart
    │   └── profile/         # personal_info_viewmodel.dart
    └── app_providers.dart   # Registration of all ViewModels/Providers
    
3. Feature-Specific Views (/views)
Each folder here represents a screen or a feature, containing the UI and its Data/Domain local logic.

Auth Feature Example

lib/views/auth/
├── login/
│   ├── data/                # login_model.dart, login_repository_impl.dart
│   ├── domain/              # login_entity.dart, login_usecase.dart
│   └── presentation/        
│       ├── screen/          # login_screen.dart (The VIEW)
│       └── widgets/         # custom_textfield.dart
├── register/
│   ├── data/                # signup_repository_impl.dart
│   └── presentation/        # register_screen.dart
└── otp_verify/
    └── presentation/        # otp_verify_screen.dart, pin_put_widget.dart

    
Community Feature Example

lib/views/community/
├── data/                    # community_model.dart, community_repo.dart
├── domain/                  # community_entity.dart
└── presentation/
    ├── screen/              # community_screen.dart, comment_post_screen.dart
    └── widgets/             # post_card.dart, reaction_button.dart
    
Course & Classroom Example

lib/views/course_screen/
├── model/                   # get_all_courses_model.dart, class_details_model.dart
└── screens/
    ├── my_class/            # my_class_screen.dart, video_player_screen.dart
    └── my_course/           # my_course_screen.dart, assets_screen.dart
## MVVM Workflow Breakdown
Model: Located in the data/ folders (e.g., login_model.dart). These are your JSON parsers and DTOs.

ViewModel: Located in presentation/viewmodels/. They call the UseCases or Repositories, handle the loading states, and notify the UI.

View: Located in views/.../screen/. These are the Flutter Widgets. They "listen" to the ViewModel and display the data.
