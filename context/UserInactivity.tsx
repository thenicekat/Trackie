import { useNoteStore } from "@/store/noteStore";
import { useRouter } from "expo-router";
import { useEffect, useRef } from "react";
import { AppState, AppStateStatus } from "react-native";
import { MMKV } from 'react-native-mmkv'

const inactivityMMKVStorage = new MMKV({
    id: 'notie.inactivity'
})

export const UserInactivityProvider = ({ children }: any) => {
    const { name } = useNoteStore();
    const appState = useRef(AppState.currentState);
    const router = useRouter();

    useEffect(() => {
        const subscription = AppState.addEventListener("change", handleAppStateChange);

        return () => {
            subscription.remove();
        }
    })

    const handleAppStateChange = (nextAppState: AppStateStatus) => {
        if (nextAppState === "background") recordStartTime();

        if (nextAppState === "active" && appState.current.match(/background/)) {
            const startTime = inactivityMMKVStorage.getNumber('startTime') || 0;
            const currentTime = Date.now();

            const timeElapsed = currentTime - startTime;
            const timeLimit = 1000 * 1; // 5 minutes (in milliseconds)

            if (timeElapsed > timeLimit) {
            }
            if (name.length > 0) router.replace("/(modals)/lock");
        }
        appState.current = nextAppState;
    }

    const recordStartTime = () => {
        inactivityMMKVStorage.set('startTime', Date.now());
    }

    return children;
}