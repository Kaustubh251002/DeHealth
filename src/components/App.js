import React, { Component } from 'react';
import logo from '../logo.png';
import './App.css';

class App extends Component {

  captureFile=(event) =>{
    event.preventDefault()
    console.log("File has been Captured")
    console.log(event.target.files[0])
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <a
            className="navbar-brand col-sm-3 col-md-2 mr-0"
            href="http://www.dappuniversity.com/bootcamp"
            target="_blank"
            rel="noopener noreferrer"
          >
            Health Records
          </a>
        </nav>
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto">
                <a
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <img src={logo} className="App-logo" alt="logo" />
                </a>
                <br/>
                <h2>Upload Health Records</h2>
                <form>
                  <input type="file" onChange={this.captureFile} />
                  <input type="submit"/>
                </form>
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
