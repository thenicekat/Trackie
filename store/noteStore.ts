import { create } from "zustand"
import { createJSONStorage, persist } from "zustand/middleware"
import { zustandStorage } from "./mmkv";

export interface Note {
    id: string;
    title: string;
    content: string;
    hidden: boolean;
}

interface NoteState {
    name: string;
    setName: (name: string) => void;

    notes: Note[];
    addNote: (note: Note) => void;
    updateNote: (note: Note) => void;
    deleteNote: (id: string) => void;

    _hasHydrated: boolean;
    setHasHydrated: (hydration: boolean) => void;
}

export const useNoteState = create<NoteState>()(
    persist(
        (set, get) => ({
            name: '',
            setName: (name: string) => set((state) => ({ ...state, name })),

            notes: [],
            addNote: (note: Note) => set((state) => ({ ...state, notes: [...state.notes, note] })),
            updateNote: (note: Note) => set((state) => ({ ...state, notes: state.notes.map((n) => n.id === note.id ? note : n) })),
            deleteNote: (id: string) => set((state) => ({ ...state, notes: state.notes.filter((note) => note.id !== id) })),

            _hasHydrated: false,
            setHasHydrated: () => set((state) => ({ ...state, _hasHydrated: true }))
        }),
        {
            name: 'accountStore',
            storage: createJSONStorage(() => zustandStorage),
            onRehydrateStorage: () => (state) => {
                if (state) {
                    state.setHasHydrated(true)
                }
            }
        }
    )
)