import { StateStorage } from 'zustand/middleware'
import { MMKV } from 'react-native-mmkv'

const zustandMMKVStorage = new MMKV({
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