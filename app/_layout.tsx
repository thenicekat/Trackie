import Colors from '@/constants/Colors';
import { UserInactivityProvider } from '@/context/UserInactivity';
import { useNoteStore } from '@/store/noteStore';
import { Ionicons } from '@expo/vector-icons';
import FontAwesome from '@expo/vector-icons/FontAwesome';
import { useFonts } from 'expo-font';
import { Link, Stack, useRouter, useSegments } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { StatusBar } from 'expo-status-bar';
import { useEffect } from 'react';
import { TouchableOpacity, Text, ActivityIndicator, View } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

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
  const { name, _hasHydrated } = useNoteStore();

  // Expo Router uses Error Boundaries to catch errors in the navigation tree.
  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  useEffect(() => {
    // console.debug(`Hydration: ${_hasHydrated} | Loaded: ${loaded} | Name: ${name}`);
    if (!_hasHydrated) return;
    if (!loaded) return;

    const inTabsGroup = segments[0] === "(tabs)";

    if (name && !inTabsGroup) {
      router.replace("/(tabs)/notes");
    } else if (!name && inTabsGroup) {
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

  return (
    <Stack>
      <Stack.Screen name="index" options={{ headerShown: false }} />

      <Stack.Screen name="onboard" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerStyle: { backgroundColor: Colors.background },
        headerLeft: () => (
          <TouchableOpacity onPress={router.back}>
            <Ionicons name="arrow-back" size={34} color={Colors.dark} />
          </TouchableOpacity>
        ),
      }} />

      <Stack.Screen name="(tabs)" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerShown: false,
      }} />

      <Stack.Screen name="(modals)/lock" options={{
        title: '',
        headerBackTitle: '',
        headerShadowVisible: false,
        headerShown: false,
        animation: 'none'
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