import React from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  enum Directions {
    Up = 4,
    Down,
    Left,
    Right
  }
  let directions = [Directions.Up, Directions.Down, Directions.Left, Directions.Right]
  console.log('directions', directions)

  interface Hoge { hogeField: string }
  interface Fuga { fugaField: string }
  const fuga = (arg: Hoge & Fuga): string => {return arg.fugaField}
  const fugaVal = fuga(({hogeField: "hooge", fugaField: "fuuga"}))
  console.log('fugaVal', fugaVal)

  return (
    <div className="App">
      コンソールで実験中
    </div>
  );
}

export default App;
