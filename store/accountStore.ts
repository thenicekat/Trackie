import { create } from "zustand"
import { createJSONStorage, persist } from "zustand/middleware"
import { zustandStorage } from "./mmkv";


interface AccountState {
    name: string;
    getName: () => string;
    setName: (name: string) => void;
}

export const useAccountStore = create<AccountState>()(
    persist(
        (set, get) => ({
            name: '',
            getName: () => get().name,
            setName: (name) => set({ name: name })
        }), {
        name: 'accountStore',
        storage: createJSONStorage(() => zustandStorage)
    }
    )
)