import Colors from '@/constants/Colors';
import { UserInactivityProvider } from '@/context/UserInactivity';
import { inactivityMMKVStorage } from '@/store/mmkv';
import { useNoteState } from '@/store/noteStore';
import { Ionicons } from '@expo/vector-icons';
import FontAwesome from '@expo/vector-icons/FontAwesome';
import { useFonts } from 'expo-font';
import { Stack, useRouter, useSegments } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { StatusBar } from 'expo-status-bar';
import { useEffect } from 'react';
import { TouchableOpacity, ActivityIndicator, View } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import * as SystemUI from "expo-system-ui"

export {
  // Catch any errors thrown by the Layout component.
  ErrorBoundary,
} from 'expo-router';

export const unstable_settings = {
  // Ensure that reloading on `/modal` keeps a back button present.
  initialRouteName: '/',
};

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

const InitialLayout = () => {
  const [loaded, error] = useFonts({
    SpaceMono: require('../assets/fonts/SpaceMono-Regular.ttf'),
    ...FontAwesome.font,
  });
  const router = useRouter();
  const segments = useSegments();
  const { name, _hasHydrated } = useNoteState();

  // Expo Router uses Error Boundaries to catch errors in the navigation tree.
  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SystemUI.setBackgroundColorAsync(Colors.background)
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  useEffect(() => {
    if (!_hasHydrated) return;
    if (!loaded) return;

    const inNotes = segments[0] === "notes";

    if (name && !inNotes) {
      if (inactivityMMKVStorage.getBoolean('lockEnabled')) {
        router.replace("/(modals)/lock");
      } else {
        router.replace("/notes");
      }
    } else if (!name && inNotes) {
      router.replace("/");
    }
  }, [_hasHydrated, loaded, name]);

  if (!loaded) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color={Colors.primary} />
      </View>
    );
  }

  const hideHeaderOptions = {
    title: '',
    headerBackTitle: '',
    headerShadowVisible: false,
    headerShown: false,
  }

  return (
    <Stack>
      <Stack.Screen name="(modals)/lock" options={hideHeaderOptions} />

      <Stack.Screen name="index" options={hideHeaderOptions} />

      <Stack.Screen name="onboard" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerStyle: { backgroundColor: Colors.background },
        headerLeft: () => (
          <TouchableOpacity onPress={() => {
            if (router.canDismiss()) {
              router.dismiss()
            } else {
              router.replace("/notes")
            }
          }}>
            <Ionicons name="arrow-back" size={34} color={Colors.dark} />
          </TouchableOpacity>
        ),
      }} />

      <Stack.Screen name="settings" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerStyle: { backgroundColor: Colors.background },
      }} />

      <Stack.Screen name="notes/index" options={hideHeaderOptions} />
      <Stack.Screen name="notes/create" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerStyle: { backgroundColor: Colors.background },
      }} />
      <Stack.Screen name="notes/edit/[id]" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerStyle: { backgroundColor: Colors.background },
      }} />


    </Stack>
  );
}

const RootLayoutNav = () => {
  return (
    <>
      <UserInactivityProvider>
        <GestureHandlerRootView style={{ flex: 1 }}>
          <StatusBar style="dark" />
          <InitialLayout />
        </GestureHandlerRootView>
      </UserInactivityProvider>
    </>
  )
}

export default RootLayoutNav;