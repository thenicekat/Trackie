import { MMKV } from "react-native-mmkv";
import { StateStorage } from 'zustand/middleware'

/**
 * MMKV Setup for Zustand.
 */
export const zustandMMKVStorage = new MMKV({
    id: 'notie.zustand'
})
export const zustandStorage: StateStorage = {
    setItem: (name, value) => {
        return zustandMMKVStorage.set(name, value)
    },
    getItem: (name) => {
        const value = zustandMMKVStorage.getString(name)
        return value ?? null
    },
    removeItem: (name) => {
        return zustandMMKVStorage.delete(name)
    },
}

/**
 * MMKV for inactivity state management.
 */
export const inactivityMMKVStorage = new MMKV({
    id: 'notie.inactivity'
})